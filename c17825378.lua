--捕食植物トリアンティス
local s,id,o=GetID()
function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	-- if you Fusion Summon a DARK Fusion Monster, you can also use cards in your Pendulum Zones as monsters on the field, as material for its Fusion Summon.
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_FUSION_MATERIAL)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_PZONE,0)
	e1:SetValue(s.mtval)
	e1:SetOperation(function() return FusionSpell.FUSION_OPERATION_INHERIT|LOCATION_MZONE end)
	-- as of 2025 May, there is no card can add LOCATION_MZONE base on material group. So we can just check pre_select_mat_location.
	e1:SetLabel(0,LOCATION_MZONE) ---  only avaliable when pre_select_mat_location contains LOCATION_MZONE, 1st number is limitaion of count materials, set 0 as infinity
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(s.ctcon)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
end

function s.mtval(e,c)
	return c and c:IsAttribute(ATTRIBUTE_DARK) and c:IsControler(e:GetHandlerPlayer())
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and r==REASON_FUSION
end
function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,0x1041,1) end
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,0x1041,1)
	if ct>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local sg=g:Select(tp,1,ct,nil)
		local sc=sg:GetFirst()
		while sc do
			if sc:AddCounter(0x1041,1) and sc:GetLevel()>1 then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_CHANGE_LEVEL)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetCondition(s.lvcon)
				e1:SetValue(1)
				sc:RegisterEffect(e1)
			end
			sc=sg:GetNext()
		end
	end
end
function s.lvcon(e)
	return e:GetHandler():GetCounter(0x1041)>0
end