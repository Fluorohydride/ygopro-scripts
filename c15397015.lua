--インスペクト・ボーダー
function c15397015.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(c15397015.sumcon)
	c:RegisterEffect(e1)
	--spsummon limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c15397015.sumlimit)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c15397015.counterop)
	c:RegisterEffect(e3)
	--adjust
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(c15397015.adjustop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,1)
	e5:SetValue(c15397015.elimit)
	e5:SetLabel(3)
	c:RegisterEffect(e5)
	e4:SetLabelObject(e5)
end
function c15397015.sumcon(e)
	return Duel.GetFieldGroupCount(e:GetHandler():GetControler(),LOCATION_MZONE,0)>0
end
function c15397015.sumlimit(e,se,sp,st,pos,tp)
	return Duel.GetFieldGroupCount(sp,LOCATION_MZONE,0)==0
end
function c15397015.counterop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return end
	if ep==0 then
		e:GetHandler():RegisterFlagEffect(15397015,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	else
		e:GetHandler():RegisterFlagEffect(15397016,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c15397015.cfilter(c,type)
	return c:IsFaceup() and c:IsType(type)
end
function c15397015.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	for i,type in ipairs({TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM,TYPE_LINK}) do
		if Duel.IsExistingMatchingCard(c15397015.cfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,type) then
			ct=ct+1
		end
	end
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	if c:GetFlagEffect(15397015)>=ct and c:GetFlagEffect(15397016)>=ct then
		te:SetLabel(2)
	elseif c:GetFlagEffect(15397015)>=ct then
		te:SetLabel(0)
	elseif c:GetFlagEffect(15397016)>=ct then
		te:SetLabel(1)
	else
		te:SetLabel(3)
	end
end
function c15397015.elimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and (e:GetLabel()==tp or e:GetLabel()==2)
end
