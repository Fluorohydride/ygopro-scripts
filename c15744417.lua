--ゴッドオーガス
---@param c Card
function c15744417.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(15744417,0))
	e1:SetCategory(CATEGORY_DICE+CATEGORY_ATKCHANGE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c15744417.target)
	e1:SetOperation(c15744417.operation)
	c:RegisterEffect(e1)
end
function c15744417.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,3)
end
function c15744417.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d1,d2,d3=Duel.TossDice(tp,3)
	local atk=(d1+d2+d3)*100
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END,2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	local res12=false
	local res34=false
	local res56=false
	if d1==d2 and d2==d3 then
		res12=true
		res34=true
		res56=true
	elseif (d1==d2 and (d1==1 or d1==2)) or (d1==d3 and (d1==1 or d1==2)) or (d2==d3 and (d2==1 or d2==2)) then
		res12=true
	elseif (d1==d2 and (d1==3 or d1==4)) or (d1==d3 and (d1==3 or d1==4)) or (d2==d3 and (d2==3 or d2==4)) then
		res34=true
	elseif (d1==d2 and (d1==5 or d1==6)) or (d1==d3 and (d1==5 or d1==6)) or (d2==d3 and (d2==5 or d2==6)) then
		res56=true
	end
	if not res12 and not res34 and not res56 then return end
	Duel.BreakEffect()
	if res12 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		c:RegisterEffect(e2)
	end
	if res34 then
		Duel.Draw(tp,2,REASON_EFFECT)
	end
	if res56 then
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DIRECT_ATTACK)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end
