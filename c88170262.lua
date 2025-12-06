--キラーチューン・リミックス
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddMaterialCodeList(c,16509007)
	--synchro summon
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsCode,16509007),nil,nil,aux.Tuner(nil),1,99)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.atkcon)
	e1:SetValue(1500)
	c:RegisterEffect(e1)
	--spsummon and th hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--double tuner check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(s.valcheck)
	c:RegisterEffect(e3)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,2,nil,TYPE_TUNER) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(21142671)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function s.cfilter(c)
	return c:IsFaceupEx() and c:IsType(TYPE_TUNER)
end
function s.atkcon(e)
	return Duel.IsExistingMatchingCard(s.cfilter,e:GetHandler():GetControler(),0,LOCATION_MZONE+LOCATION_GRAVE,1,nil)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetTurnPlayer()==1-tp
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.thfilter(c,e,tp)
	return c:IsType(TYPE_TUNER) and not c:IsType(TYPE_SYNCHRO)
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsAbleToHand())
end
function s.thfilter2(c,g,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:FilterCount(Card.IsAbleToHand,c)==1
end
function s.sporthGroup(g,e,tp)
	return g:FilterCount(s.thfilter2,nil,g,e,tp)~=0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return Duel.GetMZoneCount(tp,c)>0 and g:CheckSubGroup(s.sporthGroup,2,2,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function s.spfilter(c)
	return c:IsSynchroSummonable(nil) and c:IsType(TYPE_TUNER)
end
function s.rthfilter(c,tp,e,g)
	return c:IsAbleToHand() and g:FilterCount(Card.IsCanBeSpecialSummoned,c,e,0,tp,false,false)==1
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:SelectSubGroup(tp,s.sporthGroup,false,2,2,e,tp)
	if sg then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=sg:FilterSelect(tp,s.rthfilter,1,1,nil,tp,e,sg):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		sg:RemoveCard(tc)
		if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.AdjustAll()
			if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
				Duel.BreakEffect()
				local exg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil)
				if exg:GetCount()>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local syg=exg:Select(tp,1,1,nil)
					Duel.SynchroSummon(tp,syg:GetFirst(),nil)
				end
			end
		end
	end
end
