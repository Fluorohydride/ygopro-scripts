--フェイバリット・コンタクト
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,89943723)
	aux.AddSetNameMonsterList(c,0x3008)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.fstg)
	e1:SetOperation(s.fsop)
	c:RegisterEffect(e1)
end
function s.fsfilter1(c,e)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function s.fsfilter2(c,e,tp,m,chkf)
	if not (c:IsType(TYPE_FUSION) and aux.IsMaterialListSetCard(c,0x8)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false)) then return false end
	aux.FGoalCheckAdditional=c.hero_fusion_check or s.fscheck
	local res=c:CheckFusionMaterial(m,nil,chkf,true)
	aux.FGoalCheckAdditional=nil
	return res
end
function s.fscheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0x8)
end
function s.fscfilter(c)
	return c:IsLocation(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED) or (c:IsLocation(LOCATION_MZONE) and c:IsFacedown())
end
function s.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp|0x200
		local mg=Duel.GetMatchingGroup(s.fsfilter1,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
		return Duel.IsExistingMatchingCard(s.fsfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,chkf) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.fsop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp|0x200
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.fsfilter1),tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	local sg=Duel.GetMatchingGroup(s.fsfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		aux.FGoalCheckAdditional=tc.hero_fusion_check or s.fscheck
		local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf,true)
		aux.FGoalCheckAdditional=nil
		local cf=mat:Filter(s.fscfilter,nil)
		if cf:GetCount()>0 then
			Duel.ConfirmCards(1-tp,cf)
		end
		local ng=mat:Filter(Card.IsCode,nil,89943723)
		aux.PlaceCardsOnDeckBottom(tp,mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		if ng:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_CANNOT_TO_DECK)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e1:SetTargetRange(1,1)
			e1:SetTarget(s.tdlimit)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
		end
	end
end
function s.tdlimit(e,c)
	return c==e:GetHandler()
end
