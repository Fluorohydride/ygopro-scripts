--魔弾－ブラッディ・クラウン
function c47810543.initial_effect(c)
	c:SetUniqueOnField(1,0,47810543)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(47810543,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,47810543)
	e2:SetCondition(c47810543.condition)
	e2:SetTarget(c47810543.target)
	e2:SetOperation(c47810543.operation)
	c:RegisterEffect(e2)
end
function c47810543.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c47810543.filter(c,e,tp)
	return c:IsSetCard(0x108) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c47810543.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c47810543.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c47810543.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c47810543.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local seq=4-g:GetFirst():GetSequence()
		if Duel.CheckLocation(1-tp,LOCATION_MZONE,seq) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_DISABLE_FIELD)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabel(16+seq)
			e1:SetOperation(c47810543.disop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c47810543.disop(e,tp)
	return 0x1<<e:GetLabel()
end
