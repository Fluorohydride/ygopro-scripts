--生命吸収装置
function c14318794.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(14318794,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetLabel(0)
	e2:SetCondition(c14318794.reccon)
	e2:SetTarget(c14318794.rectg)
	e2:SetOperation(c14318794.recop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TURN_END)
	e3:SetOperation(c14318794.clearg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	if not c14318794.global_check then
		c14318794.global_check=true
		c14318794[0]={}
		c14318794[1]={}
		c14318794[2]=0
		c14318794[3]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PAY_LPCOST)
		ge1:SetOperation(c14318794.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c14318794.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
c14318794.tbl={}
c14318794.count=0
function c14318794.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==Duel.GetTurnPlayer() then
		local val=math.ceil(ev/2)
		table.insert(c14318794[ep],val)
		c14318794[ep+2]=c14318794[ep+2]+1
	end
end
function c14318794.clear(e,tp,eg,ep,ev,re,r,rp)
	c14318794.tbl={table.unpack(c14318794[Duel.GetTurnPlayer()])}
	c14318794[Duel.GetTurnPlayer()]={}
	c14318794.count=c14318794[Duel.GetTurnPlayer()+2]
	c14318794[Duel.GetTurnPlayer()+2]=0
end
function c14318794.clearg(e,tp,eg,ep,ev,re,r,rp)
	c14318794.tbl={}
	c14318794.count=0
	e:GetLabelObject():SetLabel(0)
end
function c14318794.reccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c14318794.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	local count=c14318794.count-e:GetLabel()
	if chk==0 then return count>0 and c14318794.tbl[count] end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(c14318794.tbl[count])
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,c14318794.tbl[count])
	e:SetLabel(e:GetLabel()+1)
end
function c14318794.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
