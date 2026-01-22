--CNo.1 ゲート・オブ・カオス・ヌメロン－シニューニャ
function c79747096.initial_effect(c)
	aux.AddCodeList(c,15232745,41418852)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,4,c79747096.ovfilter,aux.Stringid(79747096,0))
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79747096,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c79747096.rmcon)
	e1:SetTarget(c79747096.rmtg)
	e1:SetOperation(c79747096.rmop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_REMOVE)
	e2:SetOperation(c79747096.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79747096,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCountLimit(1)
	e3:SetCondition(c79747096.spcon)
	e3:SetTarget(c79747096.sptg)
	e3:SetOperation(c79747096.spop)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
aux.xyz_number[79747096]=1
function c79747096.ovfilter(c)
	return c:IsFaceup() and c:IsCode(15232745)
end
function c79747096.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c79747096.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c79747096.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function c79747096.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(79747096,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
	else
		e:SetLabel(0)
		c:RegisterFlagEffect(79747096,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
	end
end
function c79747096.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and e:GetHandler():GetFlagEffect(79747096)>0
		and e:GetLabelObject():GetLabel()~=Duel.GetTurnCount()
end
function c79747096.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c79747096.damfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetAttack()>0
end
function c79747096.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsEnvironment(41418852,tp,LOCATION_FZONE)
		and Duel.IsExistingMatchingCard(c79747096.damfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) then
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(c79747096.damfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
		local dam=g:GetSum(Card.GetAttack)
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
