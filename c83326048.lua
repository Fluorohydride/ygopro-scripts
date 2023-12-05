--次元障壁
function c83326048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,83326048+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c83326048.target)
	e1:SetOperation(c83326048.operation)
	c:RegisterEffect(e1)
end
function c83326048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local types={1057,1056,1063,1073,1074}
	local alist=Duel.GetFlagEffectLabel(tp,83326048)
	if not alist then
		Duel.SetTargetParam(types[Duel.SelectOption(tp,table.unpack(types))+1])
		return
	else
		local delp={}
		local comp,p=16,5
		while comp>0 do
			if alist&comp~=0 then
				table.insert(delp,p)
			end
			comp=comp>>1
			p=p-1
		end
		for k,v in ipairs(delp) do
			table.remove(types,v)
		end
	end
	Duel.SetTargetParam(types[Duel.SelectOption(tp,table.unpack(types))+1])
end
function c83326048.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ct,p=0,0
	if opt==1057 then ct=TYPE_RITUAL   p=0 end
	if opt==1056 then ct=TYPE_FUSION   p=1 end
	if opt==1063 then ct=TYPE_SYNCHRO  p=2 end
	if opt==1073 then ct=TYPE_XYZ      p=3 end
	if opt==1074 then ct=TYPE_PENDULUM p=4 end
	p=1<<p
	local alist=Duel.GetFlagEffectLabel(tp,83326048)
	if alist then
		if alist&p~=0 then return end
		alist=alist+p
	else
		alist=p
	end
	Duel.ResetFlagEffect(tp,83326048)
	Duel.RegisterFlagEffect(tp,83326048,RESET_PHASE+PHASE_END,0,1,alist)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetLabel(ct)
	e1:SetTargetRange(1,1)
	e1:SetTarget(c83326048.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c83326048.distg)
	e2:SetLabel(ct)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c83326048.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:GetOriginalType()&e:GetLabel()>0
end
function c83326048.distg(e,c)
	return c:IsType(e:GetLabel())
end