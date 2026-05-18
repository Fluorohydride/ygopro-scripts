--影牢の呪縛
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x16)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(s.ctcon)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	--atkdown
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.atkcon)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
	-- Each time you Fusion Summon a "Shaddoll" Fusion Monster, you can remove 3 Spellstone Counters from this card to use 1 appropriate face-up monster your opponent controls as 1 of the Fusion Materials.
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(s.extra_material_con)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(function(_,mc) return mc:IsFaceup() and mc:IsType(TYPE_MONSTER) end)
	e4:SetCost(s.extra_material_cost)
	e4:SetOperation(function() return FusionSpell.FUSION_OPERATION_INHERIT end)
	e4:SetValue(function(extra_material_effect,tc) return tc and tc:IsSetCard(0x9d) and tc:IsControler(extra_material_effect:GetHandlerPlayer()) end)
	e4:SetLabel(1)  --- at most 1 material per fusion effect
	c:RegisterEffect(e4)
end
function s.cfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT)
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(s.cfilter,nil)
	e:GetHandler():AddCounter(0x16,ct)
end
function s.atkcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function s.atkval(e,c)
	return e:GetHandler():GetCounter(0x16)*-100
end
function s.extra_material_con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCanRemoveCounter(tp,0x16,3,REASON_ACTION)
end
---@param e Effect
function s.extra_material_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return e:GetHandler():IsCanRemoveCounter(tp,0x16,3,REASON_ACTION)
	end
	e:GetHandler():RemoveCounter(tp,0x16,3,REASON_ACTION)
end
