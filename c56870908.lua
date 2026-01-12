--Yum☆Yum☆ヤミーズ
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,30581601)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change LP
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.lpcon)
	e2:SetOperation(s.lpop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	--special summon 2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,id+o)
	e4:SetCondition(s.spcon2)
	e4:SetCost(s.spcost2)
	e4:SetTarget(s.sptg2)
	e4:SetOperation(s.spop2)
	c:RegisterEffect(e4)
end
function s.cfilter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x1ca) and c:IsFaceup()
end
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,2,nil,tp)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	if Duel.Recover(tp,500,REASON_EFFECT)~=0 and Duel.GetLP(1-tp)>=500 then
		Duel.PayLPCost(1-tp,500)
	end
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function s.tgfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:IsAbleToGrave()
end
function s.fselect(g,e,tp)
	return g:IsExists(Card.IsCode,1,nil,30581601)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g)
end
function s.spfilter(c,e,tp,sg)
	return c:IsSetCard(0x1ca) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,sg,c)>0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local rg=Duel.GetMatchingGroup(s.tgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e)
	if chk==0 then return rg:CheckSubGroup(s.fselect,2,2,e,tp)
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=rg:SelectSubGroup(tp,s.fselect,false,2,2,e,tp)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,sg,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetTargetsRelateToChain()
	if tg:GetCount()~=2 then return end
	if Duel.SendtoGrave(tg,REASON_EFFECT)==2 and tg:IsExists(Card.IsLocation,2,nil,LOCATION_GRAVE) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil)
		local tc=g:GetFirst()
		if tc then
			tc:SetMaterial(nil)
			if Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
				tc:CompleteProcedure()
			end
		end
	end
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,100) end
	Duel.PayLPCost(tp,100)
end
function s.spfilter2(c)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0x1ca)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
	if tc then Duel.LinkSummon(tp,tc,nil) end
end
