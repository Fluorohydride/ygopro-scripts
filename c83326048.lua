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
	if not c83326048.global_check then
		c83326048.global_check=true
		c83326048[1]=-1
		c83326048[2]=-1
		c83326048[3]=-1
		c83326048[4]=-1
		c83326048[5]=-1
	end
end
function c83326048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local types={1057,1056,1063,1073,1074}
	local lastp,back=5,0
	for k,v in ipairs(c83326048) do
		if v==tp or v==2 then
			if lastp<k then back=-1 end
			table.remove(types,k+back)
			lastp=k
			back=0
		end
	end
	Duel.SetTargetParam(types[Duel.SelectOption(tp,table.unpack(types))+1])
end
function c83326048.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local ct=nil
	local p=nil
	if opt==1057 then ct=TYPE_RITUAL   p=1 end
	if opt==1056 then ct=TYPE_FUSION   p=2 end
	if opt==1063 then ct=TYPE_SYNCHRO  p=3 end
	if opt==1073 then ct=TYPE_XYZ      p=4 end
	if opt==1074 then ct=TYPE_PENDULUM p=5 end
	if c83326048[p]==tp or c83326048[p]==2 then return  end
	if p~=nil then
		if c83326048[p]==-1 then c83326048[p]=tp end
		if c83326048[p]==1-tp then c83326048[p]=2 end
	end
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