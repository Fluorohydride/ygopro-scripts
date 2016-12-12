--下克上の首飾り
function c5183693.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c5183693.filter)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c5183693.atkcon)
	e2:SetValue(c5183693.atkval)
	c:RegisterEffect(e2)
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5183693,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c5183693.tdtg)
	e4:SetOperation(c5183693.tdop)
	c:RegisterEffect(e4)
end
function c5183693.filter(c)
	return c:IsType(TYPE_NORMAL)
end
function c5183693.atkcon(e)
	if Duel.GetCurrentPhase()~=PHASE_DAMAGE_CAL then return false end
	local eqc=e:GetHandler():GetEquipTarget()
	local bc=eqc:GetBattleTarget()
	return eqc:GetLevel()>0 and bc and bc:GetLevel()>eqc:GetLevel()
end
function c5183693.atkval(e,c)
	local bc=c:GetBattleTarget()
	return (bc:GetLevel()-c:GetLevel())*500
end
function c5183693.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c5183693.tdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)
	end
end
