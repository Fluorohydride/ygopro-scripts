--禰須三破鳴比
function c71459017.initial_effect(c)
	c:EnableCounterPermit(0x58)
	--cannot be material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(c71459017.fuslimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
	--add counter
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(71459017,0))
	e5:SetCategory(CATEGORY_COUNTER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetOperation(c71459017.countop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--control
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(71459017,1))
	e7:SetCategory(CATEGORY_CONTROL)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_END)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c71459017.ctrcon)
	e7:SetTarget(c71459017.ctrtg)
	e7:SetOperation(c71459017.ctrop)
	c:RegisterEffect(e7)
	--dice
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(71459017,2))
	e8:SetCategory(CATEGORY_DICE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_CONTROL_CHANGED)
	e8:SetCountLimit(1)
	e8:SetCondition(c71459017.dicecon)
	e8:SetTarget(c71459017.dicetg)
	e8:SetOperation(c71459017.diceop)
	c:RegisterEffect(e8)
end
function c71459017.fuslimit(e,c,sumtype)
	return sumtype&SUMMON_TYPE_FUSION==SUMMON_TYPE_FUSION
end
function c71459017.countop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		c:AddCounter(0x58,6)
	end
end
function c71459017.ctrcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c71459017.ctrtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,e:GetHandler(),1,0,0)
end
function c71459017.ctrop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.GetControl(c,1-tp)
	end
end
function c71459017.dicecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x58)>0
end
function c71459017.dicetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c71459017.diceop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsCanRemoveCounter(tp,0x58,1,REASON_EFFECT) then
		local dc=Duel.TossDice(tp,1)
		if dc>c:GetCounter(0x58) then dc=c:GetCounter(0x58) end
		c:RemoveCounter(tp,0x58,dc,REASON_EFFECT)
		if c:GetCounter(0x58)==0 and Duel.Destroy(c,REASON_EFFECT)~=0 then
			Duel.Damage(tp,2000,REASON_EFFECT)
		end
	end
end
