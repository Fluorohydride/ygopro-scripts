--機皇兵廠オブリガード
function c3715284.initial_effect(c)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3715284,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,3715284)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c3715284.sptg)
	e1:SetOperation(c3715284.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3715284,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,3715284+100)
	e2:SetOperation(c3715284.regop)
	c:RegisterEffect(e2)
end
function c3715284.spfilter(c,e,tp)
	return c:IsSetCard(0x6013) and not c:IsCode(3715284) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c3715284.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>1
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.IsExistingMatchingCard(c3715284.spfilter,tp,LOCATION_DECK,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_DECK)
end
function c3715284.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c3715284.spfilter,tp,LOCATION_DECK,0,2,2,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c3715284.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c3715284.splimit(e,c)
	return not c:IsRace(RACE_MACHINE)
end
function c3715284.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c3715284.damop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c3715284.damfilter(c)
	return c:IsSetCard(0x13) and c:IsFaceup()
end
function c3715284.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c3715284.damfilter,tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_CARD,0,3715284)
	Duel.Damage(1-tp,ct*100,REASON_EFFECT)
end
