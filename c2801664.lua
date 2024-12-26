--戦華の雄－張徳
---@param c Card
function c2801664.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2801664,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,2801664)
	e1:SetCondition(c2801664.spcon)
	e1:SetTarget(c2801664.sptg)
	e1:SetOperation(c2801664.spop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c2801664.atkcon)
	e2:SetValue(c2801664.atkval)
	c:RegisterEffect(e2)
	--extra attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2801664,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,2801665)
	e3:SetCondition(c2801664.xatkcon)
	e3:SetTarget(c2801664.xatktg)
	e3:SetOperation(c2801664.xatkop)
	c:RegisterEffect(e3)
end
function c2801664.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x137)
end
function c2801664.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2801664.cfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c2801664.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c2801664.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c2801664.atkcon(e)
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c2801664.atkval(e,c)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)*300
end
function c2801664.xatkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
		and Duel.IsAbleToEnterBP()
end
function c2801664.xatktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsHasEffect(EFFECT_EXTRA_ATTACK_MONSTER) end
end
function c2801664.xatkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		c:RegisterEffect(e1)
	end
end
